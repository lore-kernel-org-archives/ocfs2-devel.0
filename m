From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Fri Aug  6 20:27:31 2004
Subject: [Ocfs2-devel] why skip zero is removed?
Message-ID: <3ACA40606221794F80A5670F0AF15F8405167C12@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

 

>-----Original Message-----
>	Directories and system files never get to this code, because
>they are not in the pagecache.  Directories do not need zeroing, as you
>know.  System files get their zeroing in ocfs_extend_file() as 
>they have
>always done.  Note that the check in ocfs_extend_file() is now
>"if (system_file)".  This check will fail for directories, so there is
>no point in adding skip_zeros to skip it.
So the drop is not caused by zeros. But now I can not reproduce it after
the 
machine is rebooted. The performance now is high again. A strange
problem.
