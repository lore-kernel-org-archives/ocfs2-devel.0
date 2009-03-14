From: Greg KH <gregkh@suse.de>
Date: Sat, 14 Mar 2009 01:21:16 -0000
Subject: [Ocfs2-devel] [patch 091/114] jbd2: Avoid possible NULL dereference
	in jbd2_journal_begin_ordered_truncate()
In-Reply-To: <20090314011649.GA26170@kroah.com>
References: <20090314010937.416083662@mini.kroah.org>
Message-ID: <20090314011044.850951987@mini.kroah.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>, Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>, Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>, Rodrigo Rubira Branco <rbranco@la.checkpoint.com>, Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, Dan Carpenter <error27@gmail.com>, mfasheh@suse.de, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>

An embedded and charset-unspecified text was scrubbed...
Name: jbd2-avoid-possible-null-dereference-in-jbd2_journal_begin_ordered_truncate.patch
Url: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20090314/01c46374/attachment.pl 
