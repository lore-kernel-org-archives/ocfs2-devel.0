From: tristan <tristan.ye@oracle.com>
Date: Tue, 02 Mar 2010 14:10:46 +0800
Subject: [Ocfs2-devel] [PATCH 0/2] Ocfs2: Add OCFS2_IOC_INFO ioctls for
 ocfs2 v6.
In-Reply-To: <4B84E4C9.9050201@oracle.com>
References: <4B84E4C9.9050201@oracle.com>
Message-ID: <4B8CABE6.9050104@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel,

Take this patch series as the latest version, sorry for bothering send 
this once again.

Now it includes the 'ocfs2_ioctl.h' in right place(say ocfs2.h), and 
also do a correction to exclude
a Makefile change which was unexpected, what's more, last version was 
sent out by tiger's mail address.
that's my fault(I was using tiger's testing machine)...

So take this version(Mar 2nd) for merging if qualified.


Regards,
Tristan.


tristan wrote:
> Hi, Joel.
>
> That's the latest v6 o2info kernel patch, it should be mostly the same 
> as 02/08 version, except for a small change which use enum instead of 
> flag bits for OCFS2_IOC_INFO type codes. these 2 patches also were atop 
> your latest 'fixes' kernel branch.
>
> Please take this one as the final version for reviewing or merging.
>
>
> Thanks,
> Tristan.
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>   
