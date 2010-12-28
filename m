From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 28 Dec 2010 14:54:58 -0800
Subject: [Ocfs2-devel] [PATCH 01/34] ocfs2: Remove unused truncate
	function from alloc.c
In-Reply-To: <1293089477-5019-1-git-send-email-tm@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
	<1293089477-5019-1-git-send-email-tm@tao.ma>
Message-ID: <20101228225458.GF9240@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 23, 2010 at 03:30:44PM +0800, Tao Ma wrote:
> From: Tao Ma <tao.ma@oracle.com>
> 
> Tristan Ye has done some refactoring against our truncate
> process, so some functions like ocfs2_prepare_truncate and
> ocfs2_free_truncate_context are no use and we'd better
> remove them.
> 
> Signed-off-by: Tao Ma <tao.ma@oracle.com>


Hmm, so we're removing dead code here? This should just go in as-is then
IMHO.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>

--
Mark Fasheh
