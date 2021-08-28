Return-Path: <SRS0=7twz=NT=oss.oracle.com=ocfs2-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E70FC432BE
	for <ocfs2-devel@archiver.kernel.org>; Sat, 28 Aug 2021 19:32:53 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0FADF60EB0
	for <ocfs2-devel@archiver.kernel.org>; Sat, 28 Aug 2021 19:32:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0FADF60EB0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=oss.oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17SCbfP1013473;
	Sat, 28 Aug 2021 19:32:52 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 3aqbjbru9s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 28 Aug 2021 19:32:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17SJPdt2121607;
	Sat, 28 Aug 2021 19:32:50 GMT
Received: from oss.oracle.com (oss-old-reserved.oracle.com [137.254.22.2])
	by userp3020.oracle.com with ESMTP id 3aqsrf3aky-1
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO);
	Sat, 28 Aug 2021 19:32:50 +0000
Received: from localhost ([127.0.0.1] helo=lb-oss.oracle.com)
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <ocfs2-devel-bounces@oss.oracle.com>)
	id 1mK44P-0003mL-R2; Sat, 28 Aug 2021 12:32:49 -0700
Received: from aserp3030.oracle.com ([141.146.126.71])
	by oss.oracle.com with esmtp (Exim 4.63)
	(envelope-from <viro@ftp.linux.org.uk>) id 1mK44O-0003m0-FY
	for ocfs2-devel@oss.oracle.com; Sat, 28 Aug 2021 12:32:48 -0700
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	17SJPai1063962
	for <ocfs2-devel@oss.oracle.com>; Sat, 28 Aug 2021 19:32:48 GMT
Received: from mx0b-00069f01.pphosted.com (mx0b-00069f01.pphosted.com
	[205.220.177.26]) by aserp3030.oracle.com with ESMTP id 3aqb69pas9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <ocfs2-devel@oss.oracle.com>; Sat, 28 Aug 2021 19:32:48 +0000
Received: from pps.filterd (m0246576.ppops.net [127.0.0.1])
	by mx0b-00069f01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id
	17SHpTRE030465
	for <ocfs2-devel@oss.oracle.com>; Sat, 28 Aug 2021 19:32:47 GMT
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [142.44.231.140])
	by mx0b-00069f01.pphosted.com with ESMTP id 3aqsw50j0p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <ocfs2-devel@oss.oracle.com>; Sat, 28 Aug 2021 19:32:47 +0000
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1mK401-00GsRY-Fl; Sat, 28 Aug 2021 19:28:17 +0000
Date: Sat, 28 Aug 2021 19:28:17 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <YSqOUb7yZ7kBoKRY@zeniv-ca.linux.org.uk>
References: <20210827164926.1726765-1-agruenba@redhat.com>
	<20210827164926.1726765-6-agruenba@redhat.com>
	<YSkz025ncjhyRmlB@zeniv-ca.linux.org.uk>
	<CAHk-=wh5p6zpgUUoY+O7e74X9BZyODhnsqvv=xqnTaLRNj3d_Q@mail.gmail.com>
	<YSk7xfcHVc7CxtQO@zeniv-ca.linux.org.uk>
	<CAHk-=wjMyZLH+ta5SohAViSc10iPj-hRnHc-KPDoj1XZCmxdBg@mail.gmail.com>
	<YSk+9cTMYi2+BFW7@zeniv-ca.linux.org.uk>
	<YSldx9uhMYhT/G8X@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YSldx9uhMYhT/G8X@zeniv-ca.linux.org.uk>
X-Source-IP: 142.44.231.140
X-ServerName: zeniv-ca.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10090
	signatures=668682
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxscore=0
	mlxlogscore=657 bulkscore=0
	malwarescore=0 suspectscore=0 clxscore=315 adultscore=0
	priorityscore=172
	impostorscore=0 spamscore=0 lowpriorityscore=0 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000
	definitions=main-2108280133 domainage_hfrom=9158
X-Spam: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10090
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
	phishscore=0 suspectscore=0
	adultscore=0 mlxscore=0 mlxlogscore=748 malwarescore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2107140000 definitions=main-2108280132
Cc: cluster-devel <cluster-devel@redhat.com>, Jan Kara <jack@suse.cz>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Christoph Hellwig <hch@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Will Deacon <will@kernel.org>, ocfs2-devel@oss.oracle.com
Subject: [Ocfs2-devel] [RFC][arm64] possible infinite loop in btrfs
	search_ioctl()
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.9
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10090 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108280132
X-Proofpoint-ORIG-GUID: NkYUMQJr0zMtvVffvnD-2ZVs3_1PDGq0
X-Proofpoint-GUID: NkYUMQJr0zMtvVffvnD-2ZVs3_1PDGq0

	AFAICS, a48b73eca4ce "btrfs: fix potential deadlock in the search ioctl"
has introduced a bug at least on arm64.

Relevant bits: in search_ioctl() we have
        while (1) {
                ret = fault_in_pages_writeable(ubuf + sk_offset,
                                               *buf_size - sk_offset);
                if (ret)
                        break;

                ret = btrfs_search_forward(root, &key, path, sk->min_transid);
                if (ret != 0) {
                        if (ret > 0)
                                ret = 0;
                        goto err;
                }
                ret = copy_to_sk(path, &key, sk, buf_size, ubuf,
                                 &sk_offset, &num_found);
                btrfs_release_path(path);
                if (ret)
                        break;

        }
and in copy_to_sk() -
                sh.objectid = key->objectid;
                sh.offset = key->offset;
                sh.type = key->type;
                sh.len = item_len;
                sh.transid = found_transid;

                /*
                 * Copy search result header. If we fault then loop again so we
                 * can fault in the pages and -EFAULT there if there's a
                 * problem. Otherwise we'll fault and then copy the buffer in
                 * properly this next time through
                 */
                if (copy_to_user_nofault(ubuf + *sk_offset, &sh, sizeof(sh))) {
                        ret = 0;
                        goto out;
                }
with sk_offset left unchanged if the very first copy_to_user_nofault() fails.

Now, consider a situation on arm64 where ubuf points to the beginning of page,
ubuf[0] can be accessed, but ubuf[16] can not (possible with MTE, AFAICS).  We do
fault_in_pages_writeable(), which succeeds.  When we get to copy_to_user_nofault()
we fail as soon as it gets past the first 16 bytes.  And we repeat everything from
scratch, with no progress made, since short copies are treated as "discard and
repeat" here.

Am I misreading what's going on there?

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
