From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 21 Jul 2009 15:20:37 -0700
Subject: [Ocfs2-devel] [PATCH 3/6] ocfs2: Initialize blocks allocated to
 local quota file
In-Reply-To: <1247673304-31080-4-git-send-email-jack@suse.cz>
References: <1247673304-31080-1-git-send-email-jack@suse.cz>
	<1247673304-31080-4-git-send-email-jack@suse.cz>
Message-ID: <20090721222037.GF19170@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Jul 15, 2009 at 05:55:01PM +0200, Jan Kara wrote:
> +	handle = ocfs2_start_trans(OCFS2_SB(sb), 3);
> +	if (IS_ERR(handle)) {
> +		status = PTR_ERR(handle);
> +		mlog_errno(status);
> +		goto out;
> +	}

	Can we define the quota credit counts in fs/ocfs2/journal.h like
all of our other transaction constants?  I just realized how many raw
numbers there are in the quota c files.  Please define the _CREDITS
values appropriately and put them in journal.h with descriptions.  You
can do this as a separate patch at the end of the series.

Joel

-- 

"I think it would be a good idea."  
        - Mahatma Ghandi, when asked what he thought of Western
          civilization

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
