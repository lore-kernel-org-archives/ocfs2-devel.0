From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 11 Jun 2008 11:50:03 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/net: Silence build warnings on
	sparc64
In-Reply-To: <1211239417-32337-1-git-send-email-sunil.mushran@oracle.com>
References: <1211239417-32337-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080611185003.GL28100@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, mroos@linux.ee, linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 04:23:37PM -0700, Sunil Mushran wrote:
> suseconds_t is type long on most arches except sparc64 where it is type int.
> This patch silences the following warnings that are generated when building
> on it.

Hmm, this seems to have fallen through the cracks. It's in ocfs2.git now
though.
	--Mark

--
Mark Fasheh
