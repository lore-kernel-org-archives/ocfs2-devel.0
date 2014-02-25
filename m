From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 25 Feb 2014 12:21:04 -0800
Subject: [Ocfs2-devel] [PATCH] Add dlm_recover_callback_support in sysfs
In-Reply-To: <20140225152839.GA3714@shrek.hsd1.tn.comcast.net>
References: <20140225152839.GA3714@shrek.hsd1.tn.comcast.net>
Message-ID: <20140225122104.41fcc13a1debd979201c71a9@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, 25 Feb 2014 09:28:44 -0600 Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:

> This is a part of the nocontrold feature which was incorporated sometime
> back.
> 
> This is required for backward compatibility of the tools, specifically the
> scenario where the tools with recovery callback is used with a kernel
> not using the recovery callbacks (older kernel + newer tools). The tools
> look for this file to understand if the kernel supports DLM recovery
> callbacks.
> 
> For kernels which support recovery callbacks but will miss this patch,
> ocfs2 will continue to use the older API and would still be able to
> mount the filesystem.
> 
> ...
>
> +static ssize_t ocfs2_dlm_recover_show(struct kobject *kobj,
> +					struct kobj_attribute *attr,
> +					char *buf)
> +{
> +	ssize_t ret;
> +	ret = snprintf(buf, PAGE_SIZE, "1\n");
> +	return ret;
> +}

That's a bit long-winded.  What's wrong with

static ssize_t ocfs2_dlm_recover_show(struct kobject *kobj,
					struct kobj_attribute *attr,
					char *buf)
{
	return snprintf(buf, PAGE_SIZE, "1\n");
}

?
