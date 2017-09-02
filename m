From: Changwei Ge <ge.changwei@h3c.com>
Date: Sat, 2 Sep 2017 03:59:39 +0000
Subject: [Ocfs2-devel] PATCH] ocfs2/cluster: trim a trailing white space
Message-ID: <63ADC13FD55D6546B7DECE290D39E373CED3448B@H3CMLB12-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

We'd better not add a white space at the tail of a line, so trim it!

Thanks,
Changwei

Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
---
  fs/ocfs2/cluster/tcp.c |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)
  mode change 100644 => 100755 fs/ocfs2/cluster/tcp.c

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
old mode 100644
new mode 100755
index 8d77922..a9b7811
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -2054,7 +2054,7 @@ static int o2net_open_listening_sock(__be32 addr, 
__be16 port)
  	ret = sock->ops->bind(sock, (struct sockaddr *)&sin, sizeof(sin));
  	if (ret < 0) {
  		printk(KERN_ERR "o2net: Error %d while binding socket@"
-		       "%pI4:%u\n", ret, &addr, ntohs(port));
+		       "%pI4:%u\n", ret, &addr, ntohs(port));
  		goto out;
  	}

-- 
1.7.9.5
