From: David Teigland <teigland@redhat.com>
Date: Thu Oct 20 09:45:36 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <20051020105755.GE11726@marowsky-bree.de>
References: <43556F8B.3060105@suse.com>
	<20051018221849.GN11488@ca-server1.us.oracle.com>
	<43558422.9040607@suse.com>
	<20051019195654.GQ24589@marowsky-bree.de>
	<20051019224221.GB4305@redhat.com>
	<20051020105755.GE11726@marowsky-bree.de>
Message-ID: <20051020144539.GA16745@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Oct 20, 2005 at 12:57:55PM +0200, Lars Marowsky-Bree wrote:
> (Also, your outline doesn't contain the possibility that the cluster
> says "No, you CAN'T mount this. Rejected!" - is this for ease of
> describing the case, or how is that implemented? Writing "2" to the
> .../mounted flag or something?)

-1 I think

> I'd much rather have all of this done in user-space prior to the actual
> mount syscall being issued.
> 
> "mount" would need a generic hook by which it could call into the
> cluster stuff (whatever it is) to a) have it authorize the mount, b)
> _know_ about the mount, c) prepare the mount if needed - by bringing
> online all pre-requisites on that node et cetera. 

I agree, that would be very nice.  I'll find some time to dig up the
mount code.

Dave
