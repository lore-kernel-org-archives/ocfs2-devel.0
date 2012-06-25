From: =?UTF-8?Q?Marek_Kr=C3=B3likowski?= <admin@wset.edu.pl>
Date: Mon, 25 Jun 2012 10:04:46 +0200
Subject: [Ocfs2-devel] fix mlog_errno in ocfs2_global_read_info
In-Reply-To: <4FE81A93.6010200@oracle.com>
References: <4FE81A93.6010200@oracle.com>
Message-ID: <C593DD0C25314743922515FB5DD8A801@tktelekom.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Don`t use usrquota and grpquota - this is amazing unstable i wait for patch 
7 month and still in progress....
And FYI this is not only this error look i got many many in dmesg when 
someone get email and he is over quota there is error in dmesg like this:
(local,29785,2):ocfs2_write_begin:1953 ERROR: status = -122
(courier-imapd,26241,1):ocfs2_write_begin:1953 ERROR: status = -122

And many many other errors with status -122... if possible disable quota or 
You get kernel panic when u write/read/move file with FS quota support on 
ocfs2 cluster.
Thanks


-----Oryginalna wiadomo??----- 
From: Tiger Yang
Sent: Monday, June 25, 2012 10:00 AM
To: ocfs2-devel at oss.oracle.com
Cc: Mark Fasheh
Subject: [Ocfs2-devel] fix mlog_errno in ocfs2_global_read_info

Hi, All,

When mount ocfs2 with option usrquota and grpquota, we will see below
message:

(mount.ocfs2,9434,1):ocfs2_global_read_info:403 ERROR: status = 24
(mount.ocfs2,9434,3):ocfs2_global_read_info:403 ERROR: status = 24

But actually this should not be a error.

In ocfs2_global_read_info, if  read_quota() succeed, status is the size
of the struct ocfs2_global_disk_dqinfo, only when it is not equal to the
correct size, it will be a error. So this positive value should be
return and should not log it as a error.

I made a patch to fix this, and in the patch I removed the redundant
mlog_errno also.

Thanks for review

Tiger

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel at oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel 
