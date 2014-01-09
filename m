From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Thu, 09 Jan 2014 07:35:05 -0600
Subject: [Ocfs2-devel] What's the need of OCFS2_INODE_MAYBE_ORPHANED?
In-Reply-To: <20140109102301.GD10565@ZenIV.linux.org.uk>
References: <CAJtY7HVQue79bLEUPXnN=fSbvcKS_mA8FUQbmaNE0dipSp1XoA@mail.gmail.com>
	<52CDFB7F.5010200@oracle.com> <52CE13AF.5080107@suse.de>
	<52CE3409.8080108@oracle.com>
	<20140109102301.GD10565@ZenIV.linux.org.uk>
Message-ID: <52CEA589.9060607@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 01/09/2014 04:23 AM, Joel Becker wrote:
> Unlink can happen from anywhere, but only the last closing node can
> actually remove the file.  MAYBE_ORPHANED tells the node to try for
> removal at close time.  It is absolutely necessary.
>

The reason I asked the query is that OCFS2_INODE_MAYBE_ORPHANED is being 
set at every dentry downconvert. Is this really necessary because every 
dentry downconvert does not turn into unlink? (I know it says maybe :/ )

Is it okay to set it when the open_lock fails or is it too late in the 
process? If another node has performed an unlink, it would need to get 
the open lock before it performs the inode wipe. So we should be safe 
that way? Is there anything incorrect in this design?


-- 
Goldwyn
