From: Mark Fasheh <mfasheh@suse.com>
Date: Sun, 7 Feb 2010 15:13:14 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: Fix printing of lockname
In-Reply-To: <1265421356-18250-1-git-send-email-sunil.mushran@oracle.com>
References: <1265421356-18250-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100207231314.GK11402@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 05, 2010 at 05:55:56PM -0800, Sunil Mushran wrote:
> The debug call printing the name of the lock resource was chopping
> off the last character. This patch fixes the problem.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

Acked-by: Mark Fasheh <mfasheh@suse.com>
	--Mark

--
Mark Fasheh
