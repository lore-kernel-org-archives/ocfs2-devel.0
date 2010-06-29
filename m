From: Patrick J. LoPresti <lopresti@gmail.com>
Date: Mon, 28 Jun 2010 19:50:19 -0700
Subject: [Ocfs2-devel] Large (> 16TiB) volumes revisited
In-Reply-To: <4C29526E.9090108@oracle.com>
References: <AANLkTimtV44iqvA-UV5gRwWygJoh8oolTraSmcRO8ndz@mail.gmail.com>
	<20100623004937.GB20090@mail.oracle.com>
	<AANLkTilj-EHDdqIN5SziVQXG3WGhvzWGxwKYXCwhTxnM@mail.gmail.com>
	<20100623013633.GC20090@mail.oracle.com>
	<AANLkTinvOQGcTDZqtn36ef0lnyLXWy51-XLbM2RR5KJl@mail.gmail.com>
	<20100624001437.GF20090@mail.oracle.com>
	<AANLkTilj3GhmxKpZ9C5QSh6w7BRYjmU-KQ6hcnSsw6gX@mail.gmail.com>
	<20100624005537.GG20090@mail.oracle.com>
	<AANLkTinCGO1OrhOPaxbpqY9WtBGMKkf3wrU3uEtYf0JH@mail.gmail.com>
	<AANLkTilw7xckG9rpMf9M5NVMNi-PXEw4AXqskPRAVYh0@mail.gmail.com>
	<AANLkTilg6R5U1nY7FrsK15bxqNeLTIveUrmhB2p5BKU3@mail.gmail.com>
	<AANLkTikqrSWpbqY8aaQhMACpgqN4FlatSzAhJdC3Zpr0@mail.gmail.com>
	<AANLkTikJOtSn1ohvfPgCrKEfBOYsmmYDNe_aFUAsGgZb@mail.gmail.com>
	<4C2942A4.1050901@oracle.com>
	<AANLkTilDa51KeFzhtkT5hbS6z0VBcBkQ2Ni09IuyR19c@mail.gmail.com>
	<4C29526E.9090108@oracle.com>
Message-ID: <AANLkTikMbNDKanpd18eIkZlZ9x6WsuZVGSUhR41Y_kYx@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jun 28, 2010 at 6:54 PM, Sunil Mushran <sunil.mushran@oracle.com> wrote:
>
> Which version of tools are you running? block64 was added after ocfs2-tools
> 1.4.2.

1.4.4 (from Debian experimental).

"-J block64" It works fine for mkfs.ocfs2; just not for tunefs.ocfs2...
