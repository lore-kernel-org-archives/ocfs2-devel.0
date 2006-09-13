From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Sep 13 11:17:41 2006
Subject: [Ocfs2-devel] cluster/heartbeat.c::compute_max_sectors is invalid.
In-Reply-To: <20060913104442.6d8a541b@mathieu.toulouse>
References: <44FFEF06.5030001@seanodes.com>
	<20060908182833.GF8792@ca-server1.us.oracle.com>
	<20060913104442.6d8a541b@mathieu.toulouse>
Message-ID: <20060913181737.GH8792@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Sep 13, 2006 at 10:44:42AM +0200, Mathieu Avila wrote:
> A proposal patch (against the 2.6.17.11 vanilla kernel) for this is
> attached. It works for me, and shouldn't break any existing device.
Ok, that patch looks good - I've put it in my 2.6.19 queue.


> And i still think that it is a bad idea to try figuring out how many
> BIOs are needed, because it really depends on the underlying
> architecture of the device. Although it might work on most hardware,
> some strange one might break one day...
Well, I'm pretty sure some other software uses that approach, but that might
just mean other software might have similar problems :)

So yeah. I don't reallly have any qualms changing ocfs2 heartbeat to a more
"natural" usage of the bio API.


Thanks!
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
