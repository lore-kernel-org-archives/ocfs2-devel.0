From: Jeff Mahoney <jeffm@suse.com>
Date: Wed Nov 22 15:47:21 2006
Subject: [Ocfs2-devel] Local FS mount
In-Reply-To: <4564DF42.2010905@oracle.com>
References: <4564DF42.2010905@oracle.com>
Message-ID: <4564E1EE.4040507@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Sunil Mushran wrote:
> http://oss.oracle.com/osswiki/OCFS2/DesignDocs/LocalMount
> 
> Please review the writeup and the patches for the Local FS Mount.
> I was hoping to get some feedback. The patch works and has been tested
> with the mainline kernel.

Thanks for releasing this Sunil! We've been looking for a way to allow
YaST to create and mount OCFS2 file systems at boot without the cluster
configured.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFFZOHuLPWxlyuTD7IRAr5LAJ4miio9e0r0Lwoz8dB6kTEd46kpbQCfUYgB
fgvqNTrgfBkRvyv7dgs/WYA=
=qtnQ
-----END PGP SIGNATURE-----
