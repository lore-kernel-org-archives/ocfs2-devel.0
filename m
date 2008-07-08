From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 8 Jul 2008 11:17:06 -0700
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: Fixes tiny race between
	mount	and recovery
In-Reply-To: <48739F16.7000205@oracle.com>
References: <1215462380-12975-1-git-send-email-sunil.mushran@oracle.com>
	<1215462380-12975-4-git-send-email-sunil.mushran@oracle.com>
	<20080707205037.GB8651@mail.oracle.com>
	<4872C7A4.1010507@oracle.com> <48739F16.7000205@oracle.com>
Message-ID: <20080708181706.GA13557@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jul 08, 2008 at 10:08:38AM -0700, Sunil Mushran wrote:
> Instead of using generation, we could use ij_pad. Renamed to
> something appropriate.

	I like that, as it is specific to the journal part and leaves
i_generation alone.  Can we see ourselves needing any other use of that
word?

Joel

> Sunil Mushran wrote:
>> Possible Solution:
>> Use the i_generation in the journal inode as a recovery counter.
>> Meaning, we increment it each time we recover the journal. That
>> is, from mount thread in ocfs2_journal_load() and from recovery
>> thread in ocfs2_replay_journal(). In both places, we have the
>> superblock lock making the writes safe.

-- 

"When ideas fail, words come in very handy." 
         - Goethe

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
