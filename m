From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Thu, 28 Jan 2010 20:51:08 -0800
Subject: [Ocfs2-devel] o2net patches
Message-ID: <1264740671-908-1-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Following 3 patches fixes:
1. rollback's reconnect fix
2. delay enotconn for sends, receives till a node reconnects/dies after a
   lost connection.
3. Correct's keepalive protocol

Thanks,
--Srini
