From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Thu Feb 21 09:43:13 2008
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2: Detect and use MS_LOOP_NO_AOPS
In-Reply-To: <1202755969-7115-3-git-send-email-sunil.mushran@oracle.com>
References: <1202755969-7115-1-git-send-email-sunil.mushran@oracle.com>
	<1202755969-7115-3-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080221174309.GA27865@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 11, 2008 at 10:52:48AM -0800, Sunil Mushran wrote:
> +#ifdef HAS_MS_LOOP_NO_AOPS
> +	/* OCFS2's prepare and commit write operations don't do any locking. */

We might want to change this comment to something like:

	/* Ocfs2 1.4 doesn't provide prepare and commit write operations */

otherwise, the patch looks fine (sob)
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
