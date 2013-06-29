From: Jensen <shencanquan@huawei.com>
Date: Sat, 29 Jun 2013 11:27:23 +0800
Subject: [Ocfs2-devel] why oracle give up dlm by disk on ocfs2? because
	performance?
Message-ID: <51CE541B.4070807@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,
   I found ocfs1.0 use the Distributed lock manager by disk. on ocfs2 why give up? because performance or other reason?

   Btw:
     on the ocfs1.0 why not use scsi-2/3 reservation to protect to update the dlm sector data?

Thanks,
Jensen.
