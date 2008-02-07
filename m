From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 07 Feb 2008 20:48:20 -0000
Subject: [Ocfs2-devel] [git patches] ocfs2 update
In-Reply-To: <20080207200944.GQ22671@ca-server1.us.oracle.com>
References: <20080207200944.GQ22671@ca-server1.us.oracle.com>
Message-ID: <20080207124745.4868e108.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Thu, 7 Feb 2008 12:09:44 -0800
Mark Fasheh <mark.fasheh@oracle.com> wrote:

>  /*
> - * dlm_register_domain: one-time setup per "domain"
> + * Compare a requested locking protocol version against the current one.
> + *
> + * If the major numbers are different, they are incompatible.
> + * If the current minor is greater than the request, they are incompatible.
> + * If the current minor is less than or equal to the request, they are
> + * compatible, and the requester should run at the current minor version.
> + */
> +static int dlm_protocol_compare(struct dlm_protocol_version *existing,
> +				struct dlm_protocol_version *request)
> +{
> +	if (existing->pv_major != request->pv_major)
> +		return 1;
> +
> +	if (existing->pv_minor > request->pv_minor)
> +		return 1;
> +
> +	if (existing->pv_minor < request->pv_minor)
> +		request->pv_minor = existing->pv_minor;
> +
> +	return 0;
> +}
> +

It's somewhat obnoxious that what appears to be a straightforward
compare-two-things-and-return-result function will actually modify one of
the things which it is allegedly comparing.

Please integrate checkpatch into your processes - this one had a few little
glitches.
