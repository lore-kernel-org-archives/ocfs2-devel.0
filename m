From: Mark Fasheh <mfasheh@suse.de>
Date: Tue, 24 Nov 2015 13:47:20 -0800
Subject: [Ocfs2-devel] [PATCH v2 1/4] ocfs2: export ocfs2_kset for
	online file check
In-Reply-To: <1446013561-22121-2-git-send-email-ghe@suse.com>
References: <1446013561-22121-1-git-send-email-ghe@suse.com>
	<1446013561-22121-2-git-send-email-ghe@suse.com>
Message-ID: <20151124214720.GU15575@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>
Cc: rgoldwyn@suse.de, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org

On Wed, Oct 28, 2015 at 02:25:58PM +0800, Gang He wrote:
> Export ocfs2_kset object from ocfs2_stackglue kernel module,
> then online file check code will create the related sysfiles
> under ocfs2_kset object.
> 
> Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>

--
Mark Fasheh
