From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Tue, 01 Sep 2015 10:22:48 +0800
Subject: [Ocfs2-devel] ocfs2 version issue
Message-ID: <55E50BF8.50004@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Goldwyn,

Ocfs2 kernel version is removed from commit
ff8fb335221e2c446b0d4cbea26be371fd2feb64 ("ocfs2: remove versioning
information"), but Oracle CRS depends on this version, and this made
Oracle CRS can't be installed. So i think we should revert this commit
and sync this version with ocfs2-tools. Do you have any other concern
about this?

Thanks,
Junxiao.
