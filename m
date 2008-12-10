From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 9 Dec 2008 17:40:02 -0800
Subject: [Ocfs2-devel] [PATCH 02/18] ocfs2: Add the on-disk structures
	for metadata	checksums.
In-Reply-To: <493F1C3D.3030700@oracle.com>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
	<1228871395-10273-3-git-send-email-joel.becker@oracle.com>
	<493F1C3D.3030700@oracle.com>
Message-ID: <20081210014002.GC20873@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Dec 10, 2008 at 09:32:45AM +0800, Tao Ma wrote:
>> diff --git a/fs/ocfs2/ocfs2_fs.h b/fs/ocfs2/ocfs2_fs.h
>> index 4ae3984..4e20f50 100644
>> --- a/fs/ocfs2/ocfs2_fs.h
>> +++ b/fs/ocfs2/ocfs2_fs.h
>> @@ -148,6 +148,9 @@
>>  /* Support for extended attributes */
>>  #define OCFS2_FEATURE_INCOMPAT_XATTR		0x0200
>>  +/* Metadata checksum and error correction */
>> +#define OCFS2_FEATURE_INCOMPAT_META_ECC		0x0800
>> +
> Is there any reason why we don't use 0x0400?

	I think that's INDEXED_DIRS

Joel

-- 

Life's Little Instruction Book #335

	"Every so often, push your luck."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
