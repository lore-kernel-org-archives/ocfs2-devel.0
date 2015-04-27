From: Xue jiufei <xuejiufei@huawei.com>
Date: Mon, 27 Apr 2015 10:51:01 +0800
Subject: [Ocfs2-devel] [PATCH 0/3] ocfs2: fix some inconsistency problems
	caused by jbd2_journal_restart()
Message-ID: <553DA415.9090403@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I found that function jbd2_journal_restart() is called some places in
ocfs2 without keeping things consistently before. However, 
jbd2_journal_restart() may commit the handle's transaction and restart
another one. If the first transaction is committed successfully
while another not, it may cause filesystem inconsistency or read only.
This is an effort to fix this kind of problems.

Any comments are appreciated, thanks!
