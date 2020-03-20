From: Matthew Wilcox <willy@infradead.org>
Date: Fri, 20 Mar 2020 10:30:40 -0700
Subject: [Ocfs2-devel] [PATCH v9 12/25] mm: Move end_index check out of
	readahead loop
In-Reply-To: <20200320165828.GB851@sol.localdomain>
References: <20200320142231.2402-1-willy@infradead.org>
	<20200320142231.2402-13-willy@infradead.org>
	<20200320165828.GB851@sol.localdomain>
Message-ID: <20200320173040.GB4971@bombadil.infradead.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 20, 2020 at 09:58:28AM -0700, Eric Biggers wrote:
> On Fri, Mar 20, 2020 at 07:22:18AM -0700, Matthew Wilcox wrote:
> > +	/* Avoid wrapping to the beginning of the file */
> > +	if (index + nr_to_read < index)
> > +		nr_to_read = ULONG_MAX - index + 1;
> > +	/* Don't read past the page containing the last byte of the file */
> > +	if (index + nr_to_read >= end_index)
> > +		nr_to_read = end_index - index + 1;
> 
> There seem to be a couple off-by-one errors here.  Shouldn't it be:
> 
> 	/* Avoid wrapping to the beginning of the file */
> 	if (index + nr_to_read < index)
> 		nr_to_read = ULONG_MAX - index;

I think it's right.  Imagine that index is ULONG_MAX.  We should read one
page (the one at ULONG_MAX).  That would be ULONG_MAX - ULONG_MAX + 1.

> 	/* Don't read past the page containing the last byte of the file */
> 	if (index + nr_to_read > end_index)
> 		nr_to_read = end_index - index + 1;
> 
> I.e., 'ULONG_MAX - index' rather than 'ULONG_MAX - index + 1', so that
> 'index + nr_to_read' is then ULONG_MAX rather than overflowed to 0.
> 
> Then 'index + nr_to_read > end_index' rather 'index + nr_to_read >= end_index',
> since otherwise nr_to_read can be increased by 1 rather than decreased or stay
> the same as expected.

Ooh, I missed the overflow case here.  It should be:

+	if (index + nr_to_read - 1 > end_index)
+		nr_to_read = end_index - index + 1;

Let's say index comes in at ULONG_MAX - 2, end_index is ULONG_MAX - 1
and nr_to_read is 8.  The first condition triggers and nr_to_read is
reduced to 3.  But then the second condition wouldn't trigger because
ULONG_MAX - 2 + 3 is 0.

With the rewrite I have in this message, ULONG_MAX - 2 + 3 - 1 is ULONG_MAX,
which is > ULONG_MAX - 1.  So the condition triggers and nr_to_read becomes
(ULONG_MAX - 1) - (ULONG_MAX - 2) + 1.  Which is -1 + 2 + 1, which is 2.
Which is the right answer because we want to read two pages; the one
at ULONG_MAX - 2 and the one at ULONG_MAX - 1.

Thank you!
