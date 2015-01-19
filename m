From: Joseph Qi <joseph.qi@huawei.com>
Date: Mon, 19 Jan 2015 21:29:37 +0800
Subject: [Ocfs2-devel] About the commit 1b56e98990
Message-ID: <54BD06C1.8030009@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Viro,
In the commit 1b56e98990 (ocfs2 syncs the wrong range...) you submitted,
you changed pos to *ppos when sync the range.
I don't think this is right, because *ppos will be changed in
generic_file_direct_write/generic_file_buffered_write, so after this
change, the sync range is not the one that we truly want.
Am I miss something?

--
Joseph
