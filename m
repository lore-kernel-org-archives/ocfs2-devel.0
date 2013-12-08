From: Mark Fasheh <mfasheh@suse.de>
Date: Sun, 8 Dec 2013 11:25:51 -0800
Subject: [Ocfs2-devel] [PATCH 4/6] Pass ocfs2_cluster_connection
	to	ocfs2_this_node
In-Reply-To: <20131112140722.GA3946@shrek.lan>
References: <20131112140722.GA3946@shrek.lan>
Message-ID: <20131208192551.GE16774@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Nov 12, 2013 at 08:07:27AM -0600, Goldwyn Rodrigues wrote:
> This is done to differentiate between using and not using controld
> and use the connection information accordingly.
> We need to be backward compatible. So, we use a new enum
> ocfs2_connection_type to identify when controld is used and when
> it is not.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
