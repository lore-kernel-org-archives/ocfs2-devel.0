From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 31 Aug 2015 13:45:55 -0700
Subject: [Ocfs2-devel] [patch 21/28] ocfs2: sysfile interfaces for
	online file check
In-Reply-To: <55de39c1.IPdBScEdTXA2lCM7%akpm@linux-foundation.org>
References: <55de39c1.IPdBScEdTXA2lCM7%akpm@linux-foundation.org>
Message-ID: <20150831204555.GZ1145@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 26, 2015 at 03:12:17PM -0700, Andrew Morton wrote:
> From: Gang He <ghe@suse.com>
> Subject: ocfs2: sysfile interfaces for online file check

...

> +static int
> +ocfs2_filecheck_args_parse(const char *buf, size_t count,
> +				struct ocfs2_filecheck_args *args)
> +{
> +	unsigned long val = 0;
> +
> +	/* too short/long args length */
> +	if ((count < 5) || (count > OCFS2_FILECHECK_ARGS_LEN))
> +		return 1;
> +
> +	if ((strncmp(buf, "FIX ", 4) == 0) ||
> +		(strncmp(buf, "fix ", 4) == 0)) {

Use strncasecmp for this please.

--
Mark Fasheh
