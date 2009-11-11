From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 11 Nov 2009 10:11:30 -0800
Subject: [Ocfs2-devel] [PATCH 01/10] ocfs2: Handle workqueue changes
In-Reply-To: <20091111025746.GB17774@mail.oracle.com>
References: <1257818413-32014-1-git-send-email-sunil.mushran@oracle.com>
	<1257818413-32014-2-git-send-email-sunil.mushran@oracle.com>
	<20091111025746.GB17774@mail.oracle.com>
Message-ID: <4AFAFE52.3040305@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> 	Rather than include kapi-compat/include/workqueue.h at all
> times, I'd really like to only include it when necessary.  That way you
> can build the driver against mainline even when there is no kapi-compat
> directory.
> 	Can't we have an fs/ocfs2/kapi-default.h that has defines for
> when we're against mainline?  Include it from fs/ocfs2/ocfs2.h.  For
> this patch, it would include:
>
> #ifndef KAPI_INIT_WORK
> typedef struct work_struct kapi_work_struct_t;
> # define work_to_object(a, b, c)		container_of(a, b, c)
> # define KAPI_INIT_WORK(a, b, c)		INIT_WORK(a, b)
> # define KAPI_INIT_DELAYED_WORK(a, b, c)	INIT_DELAYED_WORK(a, b)
> #endif
>   

Yeah, that's a good idea.
