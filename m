From: Mark Fasheh <mfasheh@suse.de>
Date: Tue, 24 Nov 2015 13:52:50 -0800
Subject: [Ocfs2-devel] [PATCH v2 2/4] ocfs2: sysfile interfaces for
 online file check
In-Reply-To: <1446013561-22121-3-git-send-email-ghe@suse.com>
References: <1446013561-22121-1-git-send-email-ghe@suse.com>
	<1446013561-22121-3-git-send-email-ghe@suse.com>
Message-ID: <20151124215250.GV15575@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>
Cc: rgoldwyn@suse.de, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Wed, Oct 28, 2015 at 02:25:59PM +0800, Gang He wrote:
> Implement online file check sysfile interfaces, e.g.
> how to create the related sysfile according to device name,
> how to display/handle file check request from the sysfile.
> 
> Signed-off-by: Gang He <ghe@suse.com>

FYI, This looks generally fine to me however we should address Junxiao's concerns
before it goes any further.
	--Mark

--
Mark Fasheh
