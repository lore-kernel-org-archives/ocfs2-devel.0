From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 10 Nov 2009 18:57:46 -0800
Subject: [Ocfs2-devel] [PATCH 01/10] ocfs2: Handle workqueue changes
In-Reply-To: <1257818413-32014-2-git-send-email-sunil.mushran@oracle.com>
References: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
	<1257818413-32014-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20091111025746.GB17774@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Nov 09, 2009 at 06:00:04PM -0800, Sunil Mushran wrote:
> diff --git a/kapi-compat/include/workqueue.h b/kapi-compat/include/workqueue.h
> new file mode 100644
> index 0000000..24dfe2d
> --- /dev/null
> +++ b/kapi-compat/include/workqueue.h
> @@ -0,0 +1,17 @@
> +#ifndef KAPI_WORKQUEUE_H
> +#define KAPI_WORKQUEUE_H
> +
> +#ifdef NO_DELAYED_WORK_STRUCT
> +# define delayed_work				work_struct
> +typedef void kapi_work_struct_t;
> +# define work_to_object(a, b, c)		(a)
> +# define KAPI_INIT_WORK(a, b, c)		INIT_WORK(a, b, c)
> +# define KAPI_INIT_DELAYED_WORK(a, b, c)	INIT_WORK(a, b, c)
> +#else
> +typedef struct work_struct kapi_work_struct_t;
> +# define work_to_object(a, b, c)		container_of(a, b, c)
> +# define KAPI_INIT_WORK(a, b, c)		INIT_WORK(a, b)
> +# define KAPI_INIT_DELAYED_WORK(a, b, c)	INIT_DELAYED_WORK(a, b)
> +#endif
> +
> +#endif

	Rather than include kapi-compat/include/workqueue.h at all
times, I'd really like to only include it when necessary.  That way you
can build the driver against mainline even when there is no kapi-compat
directory.
	Can't we have an fs/ocfs2/kapi-default.h that has defines for
when we're against mainline?  Include it from fs/ocfs2/ocfs2.h.  For
this patch, it would include:

#ifndef KAPI_INIT_WORK
typedef struct work_struct kapi_work_struct_t;
# define work_to_object(a, b, c)		container_of(a, b, c)
# define KAPI_INIT_WORK(a, b, c)		INIT_WORK(a, b)
# define KAPI_INIT_DELAYED_WORK(a, b, c)	INIT_DELAYED_WORK(a, b)
#endif

Joel

-- 

#!/bin/perl -sp0777i<X+d*lMLa^*lN%0]dsXx++lMlN/dsM0<j]dsj
$/=unpack('H*',$_);$_=`echo 16dio\U$k"SK$/SM$n\EsN0p[lN*1
lK[d2%Sa2/d0$^Ixp"|dc`;s/\W//g;$_=pack('H*',/((..)*)$/)

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
