From: Mark Fasheh <mfasheh@suse.de>
Date: Tue, 25 Feb 2014 10:58:06 -0800
Subject: [Ocfs2-devel] [PATCH 3/6] quota: Provide function to grab quota
	structure	reference
In-Reply-To: <1392975904-16944-4-git-send-email-jack@suse.cz>
References: <1392975904-16944-1-git-send-email-jack@suse.cz>
	<1392975904-16944-4-git-send-email-jack@suse.cz>
Message-ID: <20140225185806.GH5716@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 21, 2014 at 10:45:01AM +0100, Jan Kara wrote:
> Provide dqgrab() function to get quota structure reference when we are
> sure it already has at least one active reference. Make use of this
> function inside quota code.
> 
> Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
