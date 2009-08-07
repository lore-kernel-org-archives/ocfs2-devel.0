From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 7 Aug 2009 13:19:34 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Initialize the cluster we're
 writing to in a non-sparse extend
In-Reply-To: <1249600378-18706-2-git-send-email-sunil.mushran@oracle.com>
References: <1249600378-18706-1-git-send-email-sunil.mushran@oracle.com>
	<1249600378-18706-2-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20090807201934.GD30923@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 06, 2009 at 04:12:58PM -0700, Sunil Mushran wrote:
> In a non-sparse extend, we correctly allocate (and zero) the clusters between
> the old_i_size and pos, but we don't zero the portions of the cluster we're
> writing to outside of pos<->len.
> 
> It handles clustersize > pagesize and blocksize < pagesize.
> 
> [Cleaned up by Joel Becker.]
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

	This is now in the fixes branch of ocfs2.git.

Joel

-- 

"Born under a bad sign.
 I been down since I began to crawl.
 If it wasn't for bad luck,
 I wouldn't have no luck at all."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
