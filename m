From: Cahill, Ben M <ben.m.cahill@intel.com>
Date: Fri Jul  2 16:27:05 2004
Subject: [Ocfs2-devel] 
	FYI:  RedHat open-sourced GFS/DLM/cluster stuff last week
Message-ID: <0604335B7764D141945E20215310596002299ED3@orsmsx404.amr.corp.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

If you haven't heard about it already, I thought folks on the list might
be interested to know that RH open-sourced (GPL) a whole bunch of stuff
that had been Sistina's commercial software offering for shared/cluster
filesystem (GFS) and related support.

The biggest surprise for me was that it includes a "redesigned from the
ground up" distributed lock manager (DLM) modeled after the same
VaxCluster/VMS DLM that inspired OpenDLM.  It also includes the g-lock
layer that I was talking about a week or two ago, so you can plug in
different lock managers and perform operations at specific times during
the lifetime of a specific lock type.

There's some good reading about the whole GFS/DLM/cluster thing at:

http://people.redhat.com/~teigland/sca.pdf

The cluster project page:

http://sources.redhat.com/cluster/

And the specific GFS project page:

http://sources.redhat.com/cluster/gfs/

CVS in the project pages contains stuff for 2.6.7.  Source for 2.4 GFS
is at:

ftp://ftp.redhat.com/pub/redhat/linux/enterprise/3/en/RHGFS/i386/SRPMS/

although I haven't been successful in accessing that, yet.  Daniel
Phillips (RedHat) said that doesn't contain the latest goodies
(including DLM IIRC).

-- Ben --

Opinions are mine, not Intel's 
