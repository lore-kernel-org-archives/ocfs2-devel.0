From: Lynch, Rusty <rusty.lynch@intel.com>
Date: Wed Apr 28 17:17:45 2004
Subject: [Ocfs2-devel] R867 still crash on 2.4.20
Message-ID: <032EB457B9DBC540BFB1B7B519C78B0E0411BA54@orsmsx404.jf.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> On Wed, Apr 28, 2004 at 09:48:05AM +0800, ling-linux wrote:
>> I've checked out the newest one rivision 867, on 2.4.20, when
mounting,
>> it still crashs.
>My svn tree shows the latest revision at 873...
>
>> ==========
>> <1> Unable to handle kernel NULL point dereference at virtual address
>> 0000000.
>> Have you ever tried on 2.4 kernel?  Can you reproduce this?
>I run it on a 2.4 kernel all the time! :)
>Do you have a full stack trace? As in, what's the kernel output!
>	--Mark

I just tried svn version 873 on both a UP and SMP 2.4.25 kernel with no
problems. I can mount, fill the volume full of files, move stuff around,
delete stuff, and umount.  

    --rusty
