From: Marcos E. Matsunaga <Marcos.Matsunaga@oracle.com>
Date: Wed, 13 Aug 2008 15:10:33 -0400
Subject: [Ocfs2-devel] [PATCH 0/3] Dynamic local alloc (halfway there)
In-Reply-To: <1217536922-28328-1-git-send-email-mfasheh@suse.com>
References: <1217536922-28328-1-git-send-email-mfasheh@suse.com>
Message-ID: <48A331A9.7000404@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I ran tests on mainline.

The times in average goes up 3-4 times and then comes back to normal. I 
had some hard times with the kernel because at some point it starts to 
dump stacks for processes that stay too long without responding. Some of 
the systems had times over 3-4 times going up to about 10 times, but my 
guess is that it was related to the dumps as the systems get very slow 
at that point.

I'm planning to leave it running again, but disabling the dumps. I'm not 
really sure it will have much of an effect in terms of performance 
impact, but I'll try.


Regards,

Marcos Eduardo Matsunaga

Oracle USA
Linux Engineering

?The statements and opinions expressed here are my own and do not
necessarily represent those of Oracle Corporation.?



Mark Fasheh wrote:
> The following patches against 2.6.26-rc1 implement the 1st part of dynamic
> local alloc support - allowing the allocator to shrink, and re-enable itself
> after being disabled. Growing the allocator beyond it's default will follow
> soon, once I have time to complete the implementation and testing. In the
> meantime, this series hopefully fixes at least one problem on long-running
> tests where the local alloc file gets disabled.
>
> Also included is a patch which adds a per-mountpoint debugfs file for
> tracking local alloc state. More state will be added to that patch once
> dynamic local alloc support is complete.
> 	--Mark
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>   
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080813/d66d0b12/attachment.html 
