Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc245.phx1.oracleemaildelivery.com (aib29ajc245.phx1.oracleemaildelivery.com [192.29.103.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9175C43217
	for <ocfs2-devel@archiver.kernel.org>; Thu,  7 Apr 2022 03:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9ROUAd4i4xbD+jjf7tJlC5UStZuQg0jjht69+2CfoKw=;
 b=I4QvELKeBySTzKXCKye5VvEl/Sd+G6oVC3frZmAlUziWBwWg/f1taI5xLuETDjEUY2+1f5hISGvQ
   SAknh+wB4nM47E9OGtfj2PMnX/5QLciBzZT1DycBkVt0g7NSQHAlutNubt8ElJTTwekTq+1/rQS6
   ZH+SSJY5n9QCygMUzk1KW+PkzwpIVYjne9K0eFJ80G4mfbGsyh0teLE9SG6Q21qFw4dSemt7fVEp
   dEB9Sta4k11/L+WxxlX7jbk8UWRuO6365c52PJhqPAOFD25NraXuijEV4rOjIQjYc8OD24HN8XeF
   KHKoh3sAnCim0KS6G8+Y5dG7Qwg3wMU4gzDUWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=9ROUAd4i4xbD+jjf7tJlC5UStZuQg0jjht69+2CfoKw=;
 b=m2YXjWOimVF3uy+gFHo024EfjFfULTeu27a/XGG3hR7lFatxwdTz4hzoyh/0oaZoa3MaS0Ss1Bna
   8S8c4U8nOu1juJUDnHdJKxztxVs+DPvw/OBw+TeIUVPBFZqNuCQn94pe8E71bpwHJ5mFG4jUj/fW
   KeHHMZTg5O0nU0HgfKAvDLX66aLKGux8O8YAIIr8Rcj/kKT4JgrHZczQSkihoiLjeidGlhPmm7pA
   WJ3W7s+CatgV2r4JE+dkyWlsl171Vgx7SodQDBctUNL9eCmB7JmSkP4E04N55XUH7F1fzTYwVHUN
   TrqzlswrwUbUniqYFbeoSEytTd3JZeeVt3ZByQ==
Received: by omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220319 64bit (built Mar 19
 2022))
 with ESMTPS id <0R9Y00GAE9CJQF90@omta-ad1-fd1-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Thu, 07 Apr 2022 03:21:55 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc :
 subject : from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=MwpJLE0ch36RZGcSE+/AeVbeOa9UnzSlj2os7foWWmM=;
 b=BpVrgP7pZM2rYu5nt2t4F2ysbF7RJDV+g9efkP5dlSDOob3JAcqdY2u9AXbeQp1X2+Im
 vMrro2GAz9Ynd9mCgwOafDJ8CRk2pV9i43l+iHJewXJYg1reuA2CVL00+vBPMQnjuau5
 vzUTtYMpLEyWtLwkvvwVt2k+Hw7QsrY5PMlkAensS6qqS7A4356N8aS5Cr2bs1Z9EJbK
 5xbQEKdb9oE2mcV1Jk/OLsVAQA2qfyM1kNXeP24E9wfqVwsb76trveL/s5sMReitLnLP
 t/FS7582ACLN0GXLcJvvOyLgj6pvU3LQW5g+LfnQ+fEkQa9/g0dqfQwTNTetZHI1MdxE 8A==
Authentication-results: aserp3010.oracle.com; spf=softfail
 smtp.mailfrom=martin.petersen@oracle.com; dkim=pass
 header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com;
 dmarc=none header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVcC/0dY90tGXERx6Fsenct1oks6g9WgWMwmEnnrisdBW51+jnwTjgBV1DoeQ3362VN2P1984QZ7LZki7/vFKqKM11ixGN3p5H7wYSCUzJce8F5txvJRHI0zgGY3FQR/rXYrD9jU9MYPc0ZYpYPaMealztQz21euyBuyq+xnfd1DCkd8JX0Yp2yU4FhKVi00eECRCga+hVkCPwlOhkFnEkvhZuz+F+5t1I0itQUAMprSEN49G/4yDyzt/2KCUt06353dZ0gI2L5Ed7O/rdo3l+DxEmyVim6wtHvXWW3XO9/JSzVe8amGS2uByPUKHoZUi3g9VMRTgWvOUNICxSBZAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MwpJLE0ch36RZGcSE+/AeVbeOa9UnzSlj2os7foWWmM=;
 b=beS4JUxWmP+M940QWkIXp4HdiA4Mims/+CYZoKhPKlFYnVxKaNyI4TQILmp8ZMTRoWnE0qnayl+EVJR3rYrE/XNcMPNr7JEDUgMXo0b35zoCjxXI1ZfZ01sHZV/zRw2mL+faitISLGDGLCr60AO83Zh/oTFAeWD1dxglfwjjngvTWhAKnbtLEnj3ISRwnYjOtZN+2OnZloCoiJLtKzIZQNmz72XKbCpFbZYTh5iIUEkbsp9WHdGFNiiEsuREvPugH/N1kB4S6NfHtWZLQ4FXwmJG/qRGXFrvseTR8ddQTfg2deUHBWdc3NnXXWQ6CcfQRHj9acqD0QIPMZdPS8wOUA==
ARC-Authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.onmicrosoft.com;
 s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MwpJLE0ch36RZGcSE+/AeVbeOa9UnzSlj2os7foWWmM=;
 b=a4OghztVJ0+IsCmsaYwL8g5TrMraIWB7Yv/F1wB/NtBRJDBfkP2NXiTI9KJnJkSuZgfP/FiYLqJGSChMG7U6dUTN3iFrINBIW2sGcezLZYwt0MoCxHmciEqWDZ3zBOYZJcHrTPcTcrKYuGTom7UIEIDtblONoopk3bR7YYTPpis=
To: Christoph Hellwig via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Organization: Oracle Corporation
Message-id: <yq1zgkxh93c.fsf@ca-mkp.ca.oracle.com>
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-20-hch@lst.de>
Date: Wed, 06 Apr 2022 23:21:43 -0400
In-reply-to: <20220406060516.409838-20-hch@lst.de>
 (Christoph Hellwig via Ocfs2-devel's message of "Wed, 6 Apr 2022 08:05:08
 +0200")
MIME-version: 1.0
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:-1; SRV:;
 IPV:NLI; SFV:SKI; H:PH0PR10MB4759.namprd10.prod.outlook.com; PTR:; CAT:NONE;
 SFS:; DIR:INB;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 03:21:45.4061 (UTC)
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10309
 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070017
Cc: jfs-discussion@lists.sourceforge.net, linux-nvme@lists.infradead.org,
 virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com,
 linux-s390@vger.kernel.org, linux-nilfs@vger.kernel.org,
 linux-scsi@vger.kernel.org, cluster-devel@redhat.com,
 xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org,
 linux-um@lists.infradead.org, nbd@other.debian.org,
 linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
 ceph-devel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 19/27] block: remove	queue_discard_alignment
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: "Martin K. Petersen via Ocfs2-devel" <ocfs2-devel@oss.oracle.com>
Reply-to: "Martin K. Petersen" <martin.petersen@oracle.com>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ClientProxiedBy: SN6PR16CA0047.namprd16.prod.outlook.com
 (2603:10b6:805:ca::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b782a8d-1555-41a2-ce83-08da1845be65
X-MS-TrafficTypeDiagnostic: SA2PR10MB4748:EE_
X-Oracle-Tenancy: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
 QepaEAcTANYqhFRCzn6s2seCEcxa9eHESLh9KGgCJtTO7GVxRj6jqYF2bSU+XxQgfULRb/ein5xWEFqD59s2Vb0wCvggXD6j/wCYLR24r8bYmCe9O+xKVQjgDjAqbGEz1z4brZXZlUtBKXT7iidVTxZy02sTAeja+X3Jao7RsisQWZ04bzoTQKY8ECGeQnYIDQ+1m+3PzBxj3cGXUDq1mLEKpZZrunrrTICmcbxpn52nuMSCSVEd+Zk2+gaO6WfbB6IoiVGZmJWSCdG5Pr7rIgpWzmi7L9ETxaEpD9BsR2vOClbO2AUfWH9Eb1BnD6UH2yjNnEpGIVERbSFEo1ZpUvjkN2mXmZHHiWN3MsxHWVsG58FrQ6Dk3WTHjLgdOehLSRbZ3W+l+ccfeZHzqddvQGXWL30qFNe/MrN5FJjd7a1nfGvMSm6oBRXtBM02uvOBWYfMygQp9LWLdpCveLrlVo66fXpd2+6c3U5xl25fo5SyII/ECCvYJutfhIHg+ngJdo+VsWRSot2XrxfHrmZQKW4eEm7oeOYDLgu05SaNc0R0G2Q4htNEdUJ10RUISKQLOG7tmb5BDUKdL6v2IF2LNjsnPJbE8CacqQhBOAJQgSs=
X-MS-Exchange-CrossTenant-Network-Message-Id:
 6b782a8d-1555-41a2-ce83-08da1845be65
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName:
 opcVm0PkPXaf4HZxnKxOHb4X+rGBtfP/T3ZHqBFIIJITSXvlzHF2YwjgNEUwD3W+CDMVYkTMzJaqIE5gg25nzagEcSQ2vILQxddUusffC6k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-MS-Exchange-CrossPremises-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Mapi-Admin-Submission:
X-MS-Exchange-CrossPremises-MessageSource: StoreDriver
X-MS-Exchange-CrossPremises-BCC: Martin Petersen <martin.petersen@oracle.com>
X-MS-Exchange-CrossPremises-OriginalClientIPAddress: 138.3.201.44
X-MS-Exchange-CrossPremises-TransportTrafficType: Email
X-MS-Exchange-CrossPremises-Antispam-ScanContext: DIR:Originating; SFV:SKI;
 SKIP:0;
X-MS-Exchange-CrossPremises-SCL: -1
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: SA2PR10MB4748.namprd10.prod.outlook.com
X-Proofpoint-ORIG-GUID: dmpG1qTmucZRaM3I1oOLD903CHQ9m-Nl
X-Proofpoint-GUID: dmpG1qTmucZRaM3I1oOLD903CHQ9m-Nl
Reporting-Meta:
 AAF6v6zO0YueUAKyvDn52M0TcJUkyGJrslndJD5Uu+oX7okXWowcnbnUq489c1cr
 CRhrczDpr4ya4vQ7tEmslo7HUPhqhkuLDI8KEWP0yLbF3Luc9oQNUakYV7QIDANH
 W3WzR3FkEu56a0tgnyqaEZdRFhTFuewtx52hsUR9DP2gKKDWWqSwbUMTs7XAe+gV
 Leo5a7Oml1YgktpdLxA0aNsEI351qZXXHUXhua2Mg97BUux6Qqaedw28DS+Ky86M
 O9tWs7RXsohGX4RTQdtVdPKmZ+5Q5Rdk44UpcBTLATbudXVR8gnfT+zuTTGoxQL0
 dd5nNcS7dBSGw5RXSQ/gyph+JLAhQk4FhR9Mi0/B6IXxYJ/IjF1FDqZaOZCaHHhV
 AmNZgfmX7lk6SeXZJ94/zS7iGeRiEgVGN8HwXp5iriiK+jcCfYIds7telFt2zz6O
 fAWgY13yJm17LLL7cT/Aj6PRReI22CdOXm5QEO10hdpvC7iuRj1+Cw5xOEhvMiEn
 ecDt00c0ZKQkjN2lWc0NGK0QHRgweyP2OqFRNJC1x/nb


Christoph,

> Just use bdev_alignment_offset in disk_discard_alignment_show instead.
> That helpers is the same except for an always false branch that
> doesn't matter in this slow path.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
