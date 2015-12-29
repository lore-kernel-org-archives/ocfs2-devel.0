From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 29 Dec 2015 13:38:44 -0800
Subject: [Ocfs2-devel] [PATCH v3 1/4] ocfs2: export ocfs2_kset for
	online file check
In-Reply-To: <1451027779-6849-2-git-send-email-ghe@suse.com>
References: <1451027779-6849-1-git-send-email-ghe@suse.com>
	<1451027779-6849-2-git-send-email-ghe@suse.com>
Message-ID: <20151229133844.b2758dbe21604e64acd50383@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>
Cc: mfasheh@suse.com, rgoldwyn@suse.de, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri, 25 Dec 2015 15:16:16 +0800 Gang He <ghe@suse.com> wrote:

> Export ocfs2_kset object from ocfs2_stackglue kernel module,
> then online file check code will create the related sysfiles
> under ocfs2_kset object.
> 
> ...
>
> --- a/fs/ocfs2/stackglue.c
> +++ b/fs/ocfs2/stackglue.c
> @@ -629,7 +629,8 @@ static struct attribute_group ocfs2_attr_group = {
>  	.attrs = ocfs2_attrs,
>  };
>  
> -static struct kset *ocfs2_kset;
> +struct kset *ocfs2_kset;
> +EXPORT_SYMBOL_GPL(ocfs2_kset);

The EXPORT_SYMBOL is only needed if this symbol is to be referred to
from a different module.  That isn't the case here - everything which
refers to ocfs2_kset is linked into ocfs2.ko, correct?
