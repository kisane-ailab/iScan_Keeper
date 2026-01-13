const { Client } = require("ssh2");
const fs = require("fs");
const path = require("path");

// 환경변수에서 읽기 (deploy.bat에서 전달)
const config = {
  host: process.env.DASHBOARD_HOST,
  port: 22,
  username: process.env.DASHBOARD_SSH_USERNAME,
  password: process.env.DASHBOARD_SSH_PASSWORD,
};

const remotePath = process.env.DASHBOARD_REMOTE_PATH;
const dashboardPort = process.env.DASHBOARD_PORT;
const dashboardUrl = process.env.DASHBOARD_URL;

const localFile = "dashboard_standalone.tar.gz";
const remoteFile = `${remotePath}/${localFile}`;

console.log("Connecting to server...");

const conn = new Client();

conn.on("ready", () => {
  console.log("Connected!");

  // SFTP로 파일 업로드
  conn.sftp((err, sftp) => {
    if (err) {
      console.error("SFTP error:", err.message);
      conn.end();
      process.exit(1);
    }

    console.log("Uploading...");
    const readStream = fs.createReadStream(localFile);
    const writeStream = sftp.createWriteStream(remoteFile);

    writeStream.on("close", () => {
      console.log("Upload successful!");

      // 배포 명령어 실행
      const deployCmd = `cd ${remotePath} && tar -xzf ${localFile} && cp -r .next/static .next/standalone/.next/ && cp -r public .next/standalone/ && cd .next/standalone && pm2 delete dashboard-web 2>/dev/null || true && PORT=${dashboardPort} HOSTNAME=0.0.0.0 pm2 start server.js --name 'dashboard-web' && pm2 save`;

      console.log("Deploying...");
      conn.exec(deployCmd, (err, stream) => {
        if (err) {
          console.error("Exec error:", err.message);
          conn.end();
          process.exit(1);
        }

        stream
          .on("close", (code) => {
            console.log(`Done! ${dashboardUrl}`);
            conn.end();
            process.exit(code || 0);
          })
          .on("data", (data) => {
            console.log(data.toString());
          })
          .stderr.on("data", (data) => {
            console.error(data.toString());
          });
      });
    });

    writeStream.on("error", (err) => {
      console.error("Upload error:", err.message);
      conn.end();
      process.exit(1);
    });

    readStream.pipe(writeStream);
  });
});

conn.on("error", (err) => {
  console.error("Connection error:", err.message);
  process.exit(1);
});

conn.connect(config);
