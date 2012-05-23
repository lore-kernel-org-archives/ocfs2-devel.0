From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Wed, 23 May 2012 12:12:21 -0000
Subject: [Ocfs2-devel] [PATCH 01/10] string: introduce memweight
In-Reply-To: <20120523092113.GG10452@quack.suse.cz>
References: <1337520203-29147-1-git-send-email-akinobu.mita@gmail.com>
	<20120523092113.GG10452@quack.suse.cz>
Message-ID: <CAC5umyi=ridqRZGGh0+_xw0-GCN+69B33Qz82-9x4dVODGGx6w@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, Anders Larsen <al@alarsen.net>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-media@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, linux-ext4@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Theodore Ts'o <tytso@mit.edu>

2012/5/23 Jan Kara <jack@suse.cz>:
> On Sun 20-05-12 22:23:14, Akinobu Mita wrote:
>> memweight() is the function that counts the total number of bits set
>> in memory area. ?The memory area doesn't need to be aligned to
>> long-word boundary unlike bitmap_weight().
> ?Thanks for the patch. I have some comments below.

Thanks for the review.

>> @@ -824,3 +825,39 @@ void *memchr_inv(const void *start, int c, size_t bytes)
>> ? ? ? return check_bytes8(start, value, bytes % 8);
>> ?}
>> ?EXPORT_SYMBOL(memchr_inv);
>> +
>> +/**
>> + * memweight - count the total number of bits set in memory area
>> + * @ptr: pointer to the start of the area
>> + * @bytes: the size of the area
>> + */
>> +size_t memweight(const void *ptr, size_t bytes)
>> +{
>> + ? ? size_t w = 0;
>> + ? ? size_t longs;
>> + ? ? union {
>> + ? ? ? ? ? ? const void *ptr;
>> + ? ? ? ? ? ? const unsigned char *b;
>> + ? ? ? ? ? ? unsigned long address;
>> + ? ? } bitmap;
> ?Ugh, this is ugly and mostly unnecessary. Just use "const unsigned char
> *bitmap".
>
>> +
>> + ? ? for (bitmap.ptr = ptr; bytes > 0 && bitmap.address % sizeof(long);
>> + ? ? ? ? ? ? ? ? ? ? bytes--, bitmap.address++)
>> + ? ? ? ? ? ? w += hweight8(*bitmap.b);
> ?This can be:
> ? ? ? ?count = ((unsigned long)bitmap) % sizeof(long);

The count should be the size of unaligned area and it can be greater than
bytes. So

        count = min(bytes,
                    sizeof(long) - ((unsigned long)bitmap) % sizeof(long));

> ? ? ? ?while (count--) {
> ? ? ? ? ? ? ? ?w += hweight(*bitmap);
> ? ? ? ? ? ? ? ?bitmap++;
> ? ? ? ? ? ? ? ?bytes--;
> ? ? ? ?}
>> +
>> + ? ? for (longs = bytes / sizeof(long); longs > 0; ) {
>> + ? ? ? ? ? ? size_t bits = min_t(size_t, INT_MAX & ~(BITS_PER_LONG - 1),
>> + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? longs * BITS_PER_LONG);
> ?I find it highly unlikely that someone would have such a large bitmap
> (256 MB or more on 32-bit). Also the condition as you wrote it can just
> overflow so it won't have the desired effect. Just do
> ? ? ? ?BUG_ON(longs >= ULONG_MAX / BITS_PER_LONG);

The bits argument of bitmap_weight() is int type. So this should be

        BUG_ON(longs >= INT_MAX / BITS_PER_LONG);

> and remove the loop completely. If someone comes with such a huge bitmap,
> the code can be modified easily (after really closely inspecting whether
> such a huge bitmap is really well justified).

size_t memweight(const void *ptr, size_t bytes)
{
	size_t w = 0;
	size_t longs;
	const unsigned char *bitmap = ptr;

	for (; bytes > 0 && ((unsigned long)bitmap) % sizeof(long);
			bytes--, bitmap++)
		w += hweight8(*bitmap);

	longs = bytes / sizeof(long);
	BUG_ON(longs >= INT_MAX / BITS_PER_LONG);
	w += bitmap_weight((unsigned long *)bitmap, longs * BITS_PER_LONG);
	bytes -= longs * sizeof(long);
	bitmap += longs * sizeof(long);

	for (; bytes > 0; bytes--, bitmap++)
		w += hweight8(*bitmap);

	return w;
}
