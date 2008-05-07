From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 07 May 2008 17:23:32 +0800
Subject: [Ocfs2-devel] [PATCH]ocfs2-1.2: Add dput for uuid entry.
In-Reply-To: <482172FD.3040404@oracle.com>
References: <482150B9.3030002@oracle.com> <482172FD.3040404@oracle.com>
Message-ID: <48217514.9040808@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

aha, sorry for the noise. :(

dput is added in the next commit 29a7f3ada7fea5510504c5359c3f70d109aeb055.
http://www.uwsg.indiana.edu/hypermail/linux/kernel/0611.3/0126.html

So here my question is should we patch these 2 patches into our 
ocfs2-1.2 or just the 1st one?

Regards,
Tao

Tao Ma wrote:
> Some more information.
> The git commit log in the kernel is: 
> 65c333367b1aea57d58168ad3dc1df27b0227401
> http://www.uwsg.indiana.edu/hypermail/linux/kernel/0611.3/0125.html.
> 
> In this patch the debugfs_remove is modified(dput is removed), but in 
> the latest fs/debugfs/inode.c, dput is still there. So now I really 
> don't know whether this function should be modified or not.
> 
> Any advice is welcomed.
> Thanks.
> 
> Regards,
> Tao
> 
> Tao Ma wrote:
>> In ocfs2-1.2, when we mount a device, a debugfs dir will be created 
>> using its uuid. When 2 devices have the same uuid, after the 1st 
>> device is mounted, the 2nd one can't be mounted. This is OK. But the 
>> problem is that the dentry's reference is added. So when the 1st 
>> volume is umounted, none of these 2 volumes can be mounted then. So 
>> this fix solves this problem by dputting the entry(Copied from the 
>> latest debugfs code in Linux kernel).
>>
>>
>> ------------------------------------------------------------------------
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
