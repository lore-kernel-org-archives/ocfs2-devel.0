From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Thu Jul  8 00:23:03 2004
Subject: [Ocfs2-devel] posix
Message-ID: <3ACA40606221794F80A5670F0AF15F8404D650E9@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Many broken and fails are caused by unable chmod for the ocfs root =
directory.
Such as access02, because the ocfs root can not write by other users.
I've tried remove the restriction in ocfs_setattr, many case can pass.

>-----Original Message-----
>From: wim.coekaerts@oracle.com [mailto:wim.coekaerts@oracle.com]=20
>Sent: 2004=C4=EA7=D4=C27=C8=D5 17:12
>To: Ling, Xiaofeng
>Cc: Wim Coekaerts; ocfs2-devel@oss.oracle.com
>Subject: Re: [Ocfs2-devel] posix
>
>great thanks - still a bunch that fail but compared to pervious list
>this seems to behave much better.. hmm
>i guess still a bunch of probs to address
>
>On Wed, Jul 07, 2004 at 04:44:06PM +0800, Ling, Xiaofeng wrote:
>> >-----Original Message-----
>> >any chance to rerun the ltp testsuites to see how we are doing these
>> >days with all the changes ?
>> >
>> Follow is the output of LTP about file system call before  hang at
>> readdir02.
>> ---------------------------------------------------
>> TDIRECTORY=3D/ocfs ./runalltests.sh -q -f `pwd`/runtest/syscall-file
>> access01    1  PASS  :  access(accessfile, F_OK) returned 0
>> access01    2  PASS  :  access(accessfile, X_OK) returned 0
>> access01    3  PASS  :  access(accessfile, W_OK) returned 0
>> access01    4  PASS  :  access(accessfile, R_OK) returned 0
>> access02    1  BROK  :  open(test_file1, O_RDWR|O_CREAT,=20
>0644) Failed,
>> errno=3D13 :Permission denied
>> access02    2  BROK  :  Remaining cases broken
>> access02    3  BROK  :  Remaining cases broken
>> access02    4  BROK  :  Remaining cases broken
>> access03    1  PASS  :  access((char *)-1,R_OK) failed as=20
>expected with
