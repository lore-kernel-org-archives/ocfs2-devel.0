From: tridge@samba.org <tridge@samba.org>
Date: Tue Jun  5 04:11:42 2007
Subject: [Ocfs2-devel] Clustered Samba/CTDB on ocfs2 ?
In-Reply-To: <20070604215955.GB20632@ca-server1.us.oracle.com>
References: <17976.62685.567183.915000@samba.org>
	<20070502204508.GM21982@ca-server1.us.oracle.com>
	<17976.65193.79079.299940@samba.org>
	<20070502212930.GN21982@ca-server1.us.oracle.com>
	<18019.47337.745002.756250@samba.org>
	<20070604215955.GB20632@ca-server1.us.oracle.com>
Message-ID: <18021.17373.509676.569821@samba.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark,

 > But ignoring manpower issues for a second.. What sort of tests do you think
 > would help to "validate" ocfs2 + clustered samba as a usable setup? I'm
 > thinking some sort of coherency verification against two clients mounted on
 > two seperate nodes at the least. Is there a particular test suite you all
 > run on this stuff?

yes, we use the smbtorture test suite, plus windows clients. For a
start I'd suggest the following tests:

  BENCH-NBENCH
  RAW-BENCH-LOCK
  RAW-BENCH-OPEN

they are part of smbtorture in Samba4. 

I'd be happy to help with testing if someone can give me access to a
OCFS2 system.

Cheers, Tridge
