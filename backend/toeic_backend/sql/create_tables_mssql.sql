-- ====================================================================
-- HE THONG THI THU TOEIC READING - CSDL MICROSOFT SQL SERVER
-- Sinh vien: Le Vu Bao Thanh - MSSV: 2380614762
-- ====================================================================

USE ToeicExamDb;
GO

-- 1. Xoa cac bang neu da ton tai de tao moi dong bo (theo thu tu rang buoc)
IF OBJECT_ID(N'dbo.UserAnswers', N'U') IS NOT NULL DROP TABLE dbo.UserAnswers;
IF OBJECT_ID(N'dbo.UserExams', N'U') IS NOT NULL DROP TABLE dbo.UserExams;
IF OBJECT_ID(N'dbo.Answers', N'U') IS NOT NULL DROP TABLE dbo.Answers;
IF OBJECT_ID(N'dbo.Questions', N'U') IS NOT NULL DROP TABLE dbo.Questions;
IF OBJECT_ID(N'dbo.Passages', N'U') IS NOT NULL DROP TABLE dbo.Passages;
IF OBJECT_ID(N'dbo.ExamParts', N'U') IS NOT NULL DROP TABLE dbo.ExamParts;
IF OBJECT_ID(N'dbo.Exams', N'U') IS NOT NULL DROP TABLE dbo.Exams;
GO

-- 2. Bang Exams (De thi)
CREATE TABLE dbo.Exams (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    DurationMinutes INT NOT NULL DEFAULT 75,
    TotalQuestions INT NOT NULL DEFAULT 100,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE()
);
GO

-- 3. Bang ExamParts (Cac phan thi: Part 5, Part 6, Part 7)
CREATE TABLE dbo.ExamParts (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ExamId INT NOT NULL,
    PartNumber INT NOT NULL,
    Title NVARCHAR(255) NOT NULL,
    Instructions NVARCHAR(MAX) NULL,
    CONSTRAINT FK_ExamParts_Exams FOREIGN KEY (ExamId) REFERENCES dbo.Exams(Id) ON DELETE CASCADE
);
GO

-- 4. Bang Passages (Doan van doc hieu cho Part 6 va Part 7)
CREATE TABLE dbo.Passages (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    PartId INT NOT NULL,
    Title NVARCHAR(255) NULL,
    Content NVARCHAR(MAX) NOT NULL,
    ImageName NVARCHAR(255) NULL,
    OrderIndex INT NOT NULL DEFAULT 0,
    CONSTRAINT FK_Passages_ExamParts FOREIGN KEY (PartId) REFERENCES dbo.ExamParts(Id) ON DELETE CASCADE
);
GO

-- 5. Bang Questions (Cau hoi: tu cau 101 den 200)
CREATE TABLE dbo.Questions (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ExamId INT NOT NULL,
    PartId INT NOT NULL,
    PassageId INT NULL,
    QuestionNumber INT NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    Explanation NVARCHAR(MAX) NULL,
    OrderIndex INT NOT NULL DEFAULT 0,
    CONSTRAINT FK_Questions_Exams FOREIGN KEY (ExamId) REFERENCES dbo.Exams(Id) ON DELETE CASCADE,
    CONSTRAINT FK_Questions_ExamParts FOREIGN KEY (PartId) REFERENCES dbo.ExamParts(Id) ON DELETE NO ACTION,
    CONSTRAINT FK_Questions_Passages FOREIGN KEY (PassageId) REFERENCES dbo.Passages(Id) ON DELETE NO ACTION
);
GO

-- 6. Bang Answers (4 dap an A, B, C, D cho moi cau hoi)
CREATE TABLE dbo.Answers (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    QuestionId INT NOT NULL,
    Label NVARCHAR(5) NOT NULL, -- 'A', 'B', 'C', 'D'
    Content NVARCHAR(MAX) NOT NULL,
    IsCorrect BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_Answers_Questions FOREIGN KEY (QuestionId) REFERENCES dbo.Questions(Id) ON DELETE CASCADE
);
GO

-- 7. Bang UserExams (Phien lam bai thi cua hoc vien)
CREATE TABLE dbo.UserExams (
    Id NVARCHAR(64) PRIMARY KEY,
    ExamId INT NOT NULL,
    UserName NVARCHAR(255) NOT NULL,
    StartTime DATETIME2 NOT NULL,
    EndTime DATETIME2 NULL,
    DurationSeconds INT NOT NULL DEFAULT 4500,
    IsSubmitted BIT NOT NULL DEFAULT 0,
    Score INT NOT NULL DEFAULT 0,
    CorrectCount INT NOT NULL DEFAULT 0,
    WrongCount INT NOT NULL DEFAULT 0,
    SkippedCount INT NOT NULL DEFAULT 0,
    CONSTRAINT FK_UserExams_Exams FOREIGN KEY (ExamId) REFERENCES dbo.Exams(Id)
);
GO

-- 8. Bang UserAnswers (Ghi nhan lua chon cua hoc vien theo tung cau hoi)
CREATE TABLE dbo.UserAnswers (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserExamId NVARCHAR(64) NOT NULL,
    QuestionId INT NOT NULL,
    SelectedAnswer NVARCHAR(5) NULL, -- 'A', 'B', 'C', 'D' hoac NULL neu bo qua
    IsCorrect BIT NULL,
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_UserAnswers_UserExams FOREIGN KEY (UserExamId) REFERENCES dbo.UserExams(Id) ON DELETE CASCADE,
    CONSTRAINT FK_UserAnswers_Questions FOREIGN KEY (QuestionId) REFERENCES dbo.Questions(Id),
    CONSTRAINT UQ_UserAnswers_Session_Question UNIQUE (UserExamId, QuestionId)
);
GO

-- 9. Tao Index toi uu toc do truy van
CREATE INDEX IX_Questions_ExamId ON dbo.Questions(ExamId);
CREATE INDEX IX_Questions_PassageId ON dbo.Questions(PassageId);
CREATE INDEX IX_Answers_QuestionId ON dbo.Answers(QuestionId);
CREATE INDEX IX_UserAnswers_Session ON dbo.UserAnswers(UserExamId);
GO

PRINT N'DA TAO THANH CONG TOAN BO 7 BANG VA RANG BUOC TREN MICROSOFT SQL SERVER!';
GO
