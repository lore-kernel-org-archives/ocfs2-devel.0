From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 3 Aug 2009 14:15:28 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Initialize the cluster we're
	writing to in a non-sparse extend
In-Reply-To: <1249323209-28169-2-git-send-email-sunil.mushran@oracle.com>
References: <1249323209-28169-1-git-send-email-sunil.mushran@oracle.com>
	<1249323209-28169-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20090803211528.GA22913@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Aug 03, 2009 at 11:13:29AM -0700, Sunil Mushran wrote:
> In a non-sparse extend, we correctly allocate (and zero) the clusters between
> the old_i_size and pos, but we don't zero the portions of the cluster we're
> writing to outside of pos<->len.
> 
> [Cleaned up by Joel Becker.]
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

Looks reasonable to me...

Acked-by: Mark Fasheh <mfasheh@suse.com>

--
Mark Fasheh
