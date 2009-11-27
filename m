From: Andi Kleen <andi@firstfloor.org>
Date: Fri, 27 Nov 2009 21:23:36 +0100
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Implement new OCFS2_IOC_INFO
	ioctl for ocfs2.
In-Reply-To: <1259310276-7782-2-git-send-email-tristan.ye@oracle.com> (Tristan
	Ye's message of "Fri, 27 Nov 2009 16:24:36 +0800")
References: <1259310276-7782-1-git-send-email-tristan.ye@oracle.com>
	<1259310276-7782-2-git-send-email-tristan.ye@oracle.com>
Message-ID: <87tywf4szb.fsf@basil.nowhere.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tristan Ye <tristan.ye@oracle.com> writes:
> +
> +	/*
> +	 * The requests series from userspace need to be NULL-terminated.
> +	 */
> +	do {
> +		preq = *((POIR *)((char *)arg + i * sizeof(POIR)));
> +		if (!preq)
> +			break;
> +		i++;

That's the first security leak. Can be used to probe arbitary memory.
You always need to use *_user for any user space access.

> +
> +	} while (preq);
> +
> +	num_reqs = i;
> +
> +	reqs = kmalloc(sizeof(POIR) * num_reqs, GFP_KERNEL);

This is next root exploit. Think what happens when the user passes a very 
large number for num_reqs that overflows the multiplication.

If anything use kcalloc(). And limit the maximum size.

It's unclear why you just can't use separate ioctls for each request.

-Andi
-- 
ak at linux.intel.com -- Speaking for myself only.
