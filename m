From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 6 Dec 2010 17:04:24 -0800
Subject: [Ocfs2-devel] [PATCH 1/3] Ocfs2: Using macro to set/clear
 *FILLED* flags in info handler.
In-Reply-To: <1289902422-3315-2-git-send-email-tristan.ye@oracle.com>
References: <1289902422-3315-1-git-send-email-tristan.ye@oracle.com>
	<1289902422-3315-2-git-send-email-tristan.ye@oracle.com>
Message-ID: <20101207010424.GL16687@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Nov 16, 2010 at 06:13:40PM +0800, Tristan Ye wrote:
> @@ -139,7 +155,8 @@ int ocfs2_info_handle_blocksize(struct inode *inode,
>  		goto bail;
>  
>  	oib.ib_blocksize = inode->i_sb->s_blocksize;
> -	oib.ib_req.ir_flags |= OCFS2_INFO_FL_FILLED;
> +
> +	o2info_set_request_filled(oib);

	There's no need to add the extra line of whitespace for all of
these.  They're quite readable.

Joel

-- 

To spot the expert, pick the one who predicts the job will take the
longest and cost the most.

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
