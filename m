From: Jeff Mahoney <jeffm@suse.com>
Date: Wed Mar 28 08:53:36 2007
Subject: [Ocfs2-devel] mount gnenerates an error : "Unable to access
	cluster service while starting heartbeat"
In-Reply-To: <147a89290703280827w67339993y32557cfd8067733a@mail.gmail.com>
References: <147a89290703280827w67339993y32557cfd8067733a@mail.gmail.com>
Message-ID: <460A8F77.5060904@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andy Johnson wrote:
> Hello,
> I have ocfs2-tools-1.2.3. ( built from sources)
> I try:
>  mount /dev/vg1/cluster /mnt/ocfs2/
> and get:
> ocfs2_hb_ctl: Unable to access cluster service while starting heartbeat
> mount.ocfs2: Error when attempting to run /sbin/ocfs2_hb_ctl: "Operation
> not permitted"
> 
> What can be the cause of this error ? Any ideas?
> 
> (I tried it after service heartbeat stop)

Check in your dmesg output - there's usually a message indicating why
heartbeat configuration has failed.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGCo93LPWxlyuTD7IRAs5uAKCeBKih68JtrczHY/gCGhhOmaAEHACggqKm
aX8HXSI+NorpQA6dcNT6Kpo=
=of+E
-----END PGP SIGNATURE-----
