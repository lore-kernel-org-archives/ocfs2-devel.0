From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 28 Aug 2015 16:23:20 -0700
Subject: [Ocfs2-devel] [patch 06/28] ocfs2: clear the rest of the
	buffers on error
In-Reply-To: <55de3997.TTpLNRmdRzwV3er6%akpm@linux-foundation.org>
References: <55de3997.TTpLNRmdRzwV3er6%akpm@linux-foundation.org>
Message-ID: <20150828232320.GK1145@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 26, 2015 at 03:11:35PM -0700, Andrew Morton wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.de>
> Subject: ocfs2: clear the rest of the buffers on error
> 
> In case a validation fails, clear the rest of the buffers and return the
> error to the calling function.
> 
> This also facilitates bubbling up the error originating from ocfs2_error
> to calling functions.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>

--
Mark Fasheh
