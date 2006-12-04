From: Zach Brown <zach.brown@oracle.com>
Date: Mon Dec  4 15:59:24 2006
Subject: [Ocfs2-devel] [patch 3/3] ocfs2-timeout-protocol.patch
In-Reply-To: <20061204131237.894581000@suse.de>
References: <20061204130452.199246000@suse.de>
	<20061204131237.894581000@suse.de>
Message-ID: <4574B668.4000808@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


> +	if (old_sc != sc) {
> +		if (old_sc)
> +			atomic_dec(&o2net_connected_peers);
> +		else
> +			atomic_inc(&o2net_connected_peers);
> +	}

It occurs to me that this probably doesn't catch all cases.  Imagine
old_sc and sc both being non-null.  It'd dec when it shouldn't change.

How about:

if (old_sc && !sc)
	dec
else if (!old_sc && sc)
	inc

Otherwise it seems OK.

- z
