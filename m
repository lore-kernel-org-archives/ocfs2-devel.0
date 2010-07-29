From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 29 Jul 2010 11:59:06 -0700
Subject: [Ocfs2-devel] [PATCH 8/8] ocfs2/dlm: Add message
	DLM_QUERY_NODEINFO
In-Reply-To: <20100729064936.GD2591@laptop.jp.oracle.com>
References: <1279929322-9276-1-git-send-email-sunil.mushran@oracle.com>
	<1279929322-9276-9-git-send-email-sunil.mushran@oracle.com>
	<20100729064936.GD2591@laptop.jp.oracle.com>
Message-ID: <4C51CF7A.6080609@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 07/28/2010 11:49 PM, Wengang Wang wrote:
> ni_nodenum already checked in the for loop.
>    

For readability.

> Any reason we are not using kzalloc() here and in dlm_send_hbregions()?
>    

ok.

> how about remove this line and
>
> +	int locked = 0, status = -EINVAL;
>    

ok.
