From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon Feb 11 10:53:19 2008
Subject: [Ocfs2-devel] Three more patches for the 1.4 tree
Message-ID: <1202755969-7115-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

1. First patch is for forward port of detavolume. I am resending this
because few people did not get it the last time around.

2. Workaround to get loop mounts working on enterprise kernels. IIRC
this is relevant for SLES too.

3. fops->sendfile() was stripped out of the kernel in 2.6.23. Readding
as this tree needs to support older kernels.

Jeff, Please could you ensure the configure changes are ok for SLES.

Thanks
Sunil
