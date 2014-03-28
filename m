From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Fri, 28 Mar 2014 14:44:56 -0700
Subject: [Ocfs2-devel] ocfs2: Fix panic on kfree(xattr->name)
Message-ID: <1396043097-7192-1-git-send-email-srinivas.eeda@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Andrew,

can you please pull the following patch from Tetsuo Handa. It fixes a
regression in ocfs2/mainline and linux-next

Thanks,
--Srini
