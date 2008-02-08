From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Feb  8 11:18:55 2008
Subject: [Ocfs2-devel] Few more patches for ocfs2 1.4
In-Reply-To: <1202496577-21982-1-git-send-email-sunil.mushran@oracle.com>
References: <1202496577-21982-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080208191738.GU22671@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Feb 08, 2008 at 10:49:33AM -0800, Sunil Mushran wrote:
> Two forward port features, datavolume mount option and cdsl, from 1.2.
> One fixes a build issue and the last renables localalloc for local
> mounts.

Localalloc and rpm build fixes look good to me. I didn't get the datavolume
patch yet in my inbox. As far as CDSL is concerned, why don't we leave it
out for now and see how things go?
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
